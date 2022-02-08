docker pull megalinter/megalinter-dotnet:v5
# cd $(git rev-parse --show-toplevel)
$VolumeMount = $(git rev-parse --show-toplevel) + ":/tmp/lint"
$EnabledLinters = "ENABLE_LINTERS=,MARKDOWN_MARKDOWNLINT,SPELL_MISSPELL,MARKDOWN_MARKDOWN_TABLE_FORMATTER,MARKDOWN_MARKDOWN_LINK_CHECK,CREDENTIALS_SECRETLINT,YAML_YAMLLINT,SPELL_CSPELL,EDITORCONFIG_EDITORCONFIG_CHECKER,POWERSHELL_POWERSHELL"
docker run -e $EnabledLinters --name AdoBauTaskGenLinter -v $VolumeMount megalinter/megalinter-dotnet:v5
docker rm AdoBauTaskGenLinter

