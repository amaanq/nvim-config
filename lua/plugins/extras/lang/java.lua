return {

	-- add java to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "java" })
			end
		end,
	},

	-- correctly setup mason lsp / dap extensions
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "jdtls", "java-test", "java-debug-adapter" })
			end
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {
			-- configure jdtls and attach to Java ft
			setup = {
				jdtls = function(_, opts)
					-- Determine OS
					if vim.fn.has("mac") == 1 then
						CONFIG = "mac"
					elseif vim.fn.has("unix") == 1 then
						CONFIG = "linux"
					else
						print("Unsupported system")
					end

					local mason_registry = require("mason-registry")
					local jdtls_pkg = mason_registry.get_package("jdtls")
					local jdtls_path = jdtls_pkg:get_install_path()

					local java_test_pkg = mason_registry.get_package("java-test")
					local java_test_path = java_test_pkg:get_install_path()

					local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
					local java_dbg_path = java_dbg_pkg:get_install_path()

					local jar_patterns = {
						java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
						java_test_path .. "/extension/server/*.jar",
					}

					local bundles = {}
					for _, jar_pattern in ipairs(jar_patterns) do
						for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
							if not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
								table.insert(bundles, bundle)
							end
						end
					end

					vim.api.nvim_create_autocmd("FileType", {
						pattern = "java",
						callback = function()
							-- Find root of project
							local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
							local root_dir = require("jdtls.setup").find_root(root_markers)
							if root_dir == "" then
								return
							end
							local workspace_folder = "/tmp/nvim/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

							local jdtls = require("jdtls")
							local jdtls_config = vim.tbl_deep_extend("force", opts, {
								on_attach = function(client, buffer)
									require("lazyvim.plugins.lsp.format").on_attach(client, buffer)
									require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
									-- custom keymaps
									vim.keymap.set(
										"n",
										"<leader>co",
										'<cmd>lua require("jdtls").organize_imports()<cr>',
										{ buffer = buffer, desc = "Organize Imports" }
									)
									vim.keymap.set(
										"n",
										"<leader>ctc",
										'<cmd>lua require("jdtls").test_class()<cr>',
										{ buffer = buffer, desc = "Nearest Class" }
									)
									vim.keymap.set(
										"n",
										"<leader>ctm",
										'<cmd>lua require("jdtls").test_nearest_method()<cr>',
										{ buffer = buffer, desc = "Nearest Method" }
									)
									require("jdtls").setup_dap({ hotcodereplace = "auto" })
									require("jdtls").setup.add_commands()
									require("jdtls").dap.setup_dap_main_class_configs()
								end,
								cmd = {
									"java",
									"--add-modules=ALL-SYSTEM",
									"--add-opens",
									"java.base/java.util=ALL-UNNAMED",
									"--add-opens",
									"java.base/java.lang=ALL-UNNAMED",
									"--add-opens",
									"java.base/sun.nio.fs=ALL-UNNAMED",
									"-Declipse.application=org.eclipse.jdt.ls.core.id1",
									"-Dosgi.bundles.defaultStartLevel=4",
									"-Declipse.product=org.eclipse.jdt.ls.core.product",
									"-Dfile.encoding=UTF-8",
									"-DwatchParentProcess=${watch_parent_process}",
									"-noverify",
									"-XX:+UseParallelGC",
									"-XX:GCTimeRatio=4",
									"-XX:AdaptiveSizePolicyWeight=90",
									"-Dsun.zip.disableMemoryMapping=true",
									"-Xmx2G",
									"-Xms100m",
									"-jar",
									vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
									"-configuration",
									jdtls_path .. "/config_" .. CONFIG,
									"-data",
									workspace_folder,
								},
								settings = {
									java = {
										configuration = {
											updateBuildConfiguration = "automatic",
										},
										codeGeneration = {
											toString = {
												template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
											},
											useBlocks = true,
										},
										completion = {
											favoriteStaticMembers = {
												"org.junit.Assert.*",
												"org.junit.Assume.*",
												"org.junit.jupiter.api.Assertions.*",
												"org.junit.jupiter.api.Assumptions.*",
												"org.junit.jupiter.api.DynamicContainer.*",
												"org.junit.jupiter.api.DynamicTest.*",
												"org.mockito.Mockito.*",
												"org.mockito.ArgumentMatchers.*",
												"org.mockito.Answers.*",
											},
											importOrder = {
												"#",
												"java",
												"javax",
												"org",
												"com",
											},
										},
										eclipse = {
											downloadSources = true,
										},
										flags = {
											allow_incremental_sync = true,
											server_side_fuzzy_completion = true,
										},
										implementationsCodeLens = {
											enabled = false, --Don"t automatically show implementations
										},
										inlayHints = {
											parameterNames = { enabled = "literals" },
										},
										maven = {
											downloadSources = true,
										},
										referencesCodeLens = {
											enabled = false, --Don"t automatically show references
										},
										references = {
											includeDecompiledSources = true,
										},
										saveActions = {
											organizeImports = true,
										},
										signatureHelp = { enabled = true },
										sources = {
											organizeImports = {
												starThreshold = 9999,
												staticStarThreshold = 9999,
											},
										},
									},
									initializationOptions = {
										extendedClientCapabilities = {
											resolveAdditionalTextEditsSupport = true,
											progressReportProvider = false,
										},
										bundles = bundles,
									},
								},
							})
							jdtls.start_or_attach(jdtls_config)
						end,
					})
					return true
				end,
			},
		},
	},
}
