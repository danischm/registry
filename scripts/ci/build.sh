#!/bin/bash

set -o errexit -o pipefail

source ./scripts/ci/common.sh

# URL to the Pulumi conversion service.
export PULUMI_CONVERT_URL="${PULUMI_CONVERT_URL:-$(pulumi stack output --stack pulumi/tf2pulumi-service/production url)}"

printf "Compiling theme JavaScript and CSS...\n\n"
export ASSET_BUNDLE_ID="$(build_identifier)"

# Paths to the CSS and JS bundles we'll generate below. Note that environment variables
# are read by some templates during the Hugo build process.
export CSS_BUNDLE="static/css/styles.${ASSET_BUNDLE_ID}.css"
export JS_BUNDLE="static/js/bundle.min.${ASSET_BUNDLE_ID}.js"

# Relative paths to those same files, read by Hugo templates.
export REL_CSS_BUNDLE="/css/styles.${ASSET_BUNDLE_ID}.css"
export REL_JS_BUNDLE="/js/bundle.min.${ASSET_BUNDLE_ID}.js"

export LOCAL_THEME_PATH="_vendor/github.com/pulumi/pulumi-hugo/themes/default/"
yarn --cwd "${LOCAL_THEME_PATH}" run ensure
yarn --cwd "${LOCAL_THEME_PATH}" run build

# Run the local build.
yarn run build

printf "Running Hugo...\n\n"
export REPO_THEME_PATH="themes/default/"
export HUGO_BASEURL="http://$(origin_bucket_prefix)-$(build_identifier).s3-website.$(aws_region).amazonaws.com"
hugo --minify --templateMetrics --buildDrafts --buildFuture -e "preview" | grep -v -e 'WARN .* REF_NOT_FOUND'

printf "Done!\n\n"
