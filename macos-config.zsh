#conda activate myenv &&
env_name="$(echo $CONDA_DEFAULT_ENV)" &&
env_date=$(TZ=America/New_York date -Iseconds) &&

#####
#
# Backup old files
#   conda-myenv.yml
#   conda-core-myenv.yml
#   conda-spec-file-myenv.txt
#   config-report.txt
#
#####

if [[ ! -d macos-config ]]; then
  mkdir macos-config
fi &&
if [[ -f "conda-${env_name}.yml" ]]; then
  mv "conda-${env_name}.yml" "macos-config/conda-full-${env_name}-${env_date}.yml.backup"
fi &&
if [[ -f "conda-core-${env_name}.yml" ]]; then
  mv "conda-core-${env_name}.yml" "macos-config/conda-core-${env_name}-${env_date}.yml.backup"
fi &&
if [[ -f "conda-spec-file-${env_name}.txt" ]]; then
  mv "conda-spec-file-${env_name}.txt" "macos-config/conda-spec-${env_name}-${env_date}.txt.backup"
fi &&
if [[ -f "config-report.txt" ]]; then
  mv "config-report.txt" "macos-config/config-report-${env_date}.txt.backup"
fi &&

#####
#
# Generate conda config files
#
#####

# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
# This file handles both the environment's pip packages and conda packages.
conda env export > "conda-${env_name}.yml" &&                     # platform-specific
conda env export --from-history > "conda-core-${env_name}.yml" && # platform-agnostic

# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#building-identical-conda-environments
conda list --explicit > conda-spec-file-${env_name}.txt &&

#####
#
# Generate config-report.txt
#
#####

echo "#####\n#\n# HOMEBREW\n#\n#####\n\n"  > config-report.txt &&
brew config                               >> config-report.txt &&
echo "\n\n\n"                             >> config-report.txt &&
echo "#####\n#\n# ANACONDA\n#\n#####\n\n" >> config-report.txt &&
conda info                                >> config-report.txt
