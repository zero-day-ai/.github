#!/bin/bash
# ==============================================================================
# Create Component Repository
# ==============================================================================
#
# Creates a private GitHub repository for a Gibson component with:
#   - Code copied from monorepo
#   - CI/CD workflows configured
#   - Branch protection enabled
#   - Standard files (LICENSE, CODEOWNERS, .gitignore)
#
# Usage:
#   ./create-component-repo.sh <component-name> <component-type> <source-path>
#
# Example:
#   ./create-component-repo.sh dns-recon agent enterprise/agents/dns-recon
#   ./create-component-repo.sh nmap tool core/tools/discovery/nmap
#   ./create-component-repo.sh gitlab plugin enterprise/plugins/gitlab
#
# Requirements:
#   - gh CLI authenticated
#   - Git configured
#   - In monorepo root directory
#
# ==============================================================================

set -euo pipefail

# Configuration
ORG="zero-day-ai"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
TEMPLATES_DIR="${MONOREPO_ROOT}/.github/templates"
WORK_DIR="/tmp/gibson-repos"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Validate arguments
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <component-name> <component-type> <source-path>"
    echo ""
    echo "Arguments:"
    echo "  component-name  Name of the component (e.g., dns-recon, nmap, gitlab)"
    echo "  component-type  Type: agent, tool, or plugin"
    echo "  source-path     Path to component in monorepo (relative to repo root)"
    echo ""
    echo "Example:"
    echo "  $0 dns-recon agent enterprise/agents/dns-recon"
    exit 1
fi

COMPONENT_NAME="$1"
COMPONENT_TYPE="$2"
SOURCE_PATH="$3"
REPO_NAME="gibson-${COMPONENT_TYPE}-${COMPONENT_NAME}"
FULL_SOURCE_PATH="${MONOREPO_ROOT}/${SOURCE_PATH}"

# Validate component type
if [[ ! "${COMPONENT_TYPE}" =~ ^(agent|tool|plugin)$ ]]; then
    log_error "Invalid component type: ${COMPONENT_TYPE}"
    log_error "Must be one of: agent, tool, plugin"
    exit 1
fi

# Validate source path exists
if [[ ! -d "${FULL_SOURCE_PATH}" ]]; then
    log_error "Source path does not exist: ${FULL_SOURCE_PATH}"
    exit 1
fi

# Check for required files
if [[ ! -f "${FULL_SOURCE_PATH}/Dockerfile" ]]; then
    log_error "No Dockerfile found in ${FULL_SOURCE_PATH}"
    exit 1
fi

if [[ ! -f "${FULL_SOURCE_PATH}/go.mod" ]]; then
    log_error "No go.mod found in ${FULL_SOURCE_PATH}"
    exit 1
fi

# Create working directory
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

log_info "Creating repository: ${ORG}/${REPO_NAME}"

# Check if repo already exists
if gh repo view "${ORG}/${REPO_NAME}" &>/dev/null; then
    log_warn "Repository ${ORG}/${REPO_NAME} already exists"
    read -p "Delete and recreate? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deleting existing repository..."
        gh repo delete "${ORG}/${REPO_NAME}" --yes
    else
        log_error "Aborting"
        exit 1
    fi
fi

# Create private repository
log_info "Creating private repository..."
gh repo create "${ORG}/${REPO_NAME}" \
    --private \
    --description "Gibson ${COMPONENT_TYPE}: ${COMPONENT_NAME}" \
    --clone

cd "${REPO_NAME}"

# Copy source code (excluding .git if present)
log_info "Copying source code..."
rsync -av --exclude='.git' "${FULL_SOURCE_PATH}/" .

# Create .github/workflows directory
mkdir -p .github/workflows

# Copy and configure CI workflow
log_info "Configuring CI workflow..."
sed -e "s/{{COMPONENT_NAME}}/${COMPONENT_NAME}/g" \
    -e "s/{{COMPONENT_TYPE}}/${COMPONENT_TYPE}/g" \
    "${TEMPLATES_DIR}/workflows/ci.yml" > .github/workflows/ci.yml

# Copy and configure release workflow
log_info "Configuring release workflow..."
# Convert kebab-case to camelCase for Helm values
COMPONENT_NAME_CAMEL=$(echo "${COMPONENT_NAME}" | sed -r 's/-(.)/\U\1/g')
sed -e "s/{{COMPONENT_NAME}}/${COMPONENT_NAME}/g" \
    -e "s/{{COMPONENT_TYPE}}/${COMPONENT_TYPE}/g" \
    -e "s/{{COMPONENT_NAME_CAMEL}}/${COMPONENT_NAME_CAMEL}/g" \
    "${TEMPLATES_DIR}/workflows/release.yml" > .github/workflows/release.yml

# Create CODEOWNERS
log_info "Creating CODEOWNERS..."
cat > CODEOWNERS << 'EOF'
# Gibson Component Owners
# These owners will be requested for review when someone opens a PR

* @zero-day-ai/core-team
EOF

# Create LICENSE (Apache 2.0)
log_info "Creating LICENSE..."
cat > LICENSE << 'EOF'
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to the Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no theory of
      liability, whether in contract, strict liability, or tort
      (including negligence or otherwise) arising in any way out of
      the use or inability to use the Work (even if such Holder or other
      party has been advised of the possibility of such damages), shall
      any Contributor be liable to You for damages, including any direct,
      indirect, special, incidental, or consequential damages of any
      character arising as a result of this License or out of the use or
      inability to use the Work (such as, but not limited to, loss of
      goodwill, work stoppage, computer failure or malfunction, or any
      and all other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   Copyright 2024 Zero Day AI

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
EOF

# Create/update .gitignore
log_info "Creating .gitignore..."
cat > .gitignore << 'EOF'
# Binaries
bin/
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary
*.test

# Output of go coverage tool
*.out
coverage.out

# Dependency directories
vendor/

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build artifacts
dist/

# Local environment
.env
.env.local
*.local

# Debug
debug
__debug_bin
EOF

# Update README if it exists, or create one
if [[ ! -f README.md ]]; then
    log_info "Creating README.md..."
    cat > README.md << EOF
# Gibson ${COMPONENT_TYPE^}: ${COMPONENT_NAME}

Gibson ${COMPONENT_TYPE} for ${COMPONENT_NAME} operations.

## Installation

### Using Docker

\`\`\`bash
docker pull ghcr.io/${ORG}/${COMPONENT_TYPE}-${COMPONENT_NAME}:latest
\`\`\`

### Using Helm

\`\`\`yaml
${COMPONENT_TYPE}s:
  ${COMPONENT_NAME_CAMEL}:
    enabled: true
    image:
      repository: ghcr.io/${ORG}/${COMPONENT_TYPE}-${COMPONENT_NAME}
      tag: "1.0.0"
\`\`\`

## Development

### Build

\`\`\`bash
make build
\`\`\`

### Test

\`\`\`bash
make test
\`\`\`

### Docker

\`\`\`bash
make docker
\`\`\`

## License

Apache 2.0 - see [LICENSE](LICENSE)
EOF
fi

# Initial commit
log_info "Creating initial commit..."
git add -A
git commit -m "Initial commit: ${COMPONENT_NAME} ${COMPONENT_TYPE}

Migrated from monorepo at ${SOURCE_PATH}

Components:
- Source code from monorepo
- CI workflow (lint, test, build)
- Release workflow (Docker build, ghcr.io push, Trivy scan)
- Standard files (LICENSE, CODEOWNERS, .gitignore)
"

# Push to remote
log_info "Pushing to remote..."
git push -u origin main

# Configure branch protection (requires GitHub Pro for private repos)
log_info "Configuring branch protection..."
if gh api repos/${ORG}/${REPO_NAME}/branches/main/protection \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -f required_status_checks='{"strict":true,"contexts":["Test","Lint","Build"]}' \
    -f enforce_admins=false \
    -f required_pull_request_reviews='{"required_approving_review_count":1}' \
    -f restrictions=null \
    -f allow_force_pushes=false \
    -f allow_deletions=false 2>/dev/null; then
    log_info "Branch protection configured"
else
    log_warn "Branch protection skipped (requires GitHub Pro for private repos)"
fi

log_info "Repository created successfully!"
log_info "URL: https://github.com/${ORG}/${REPO_NAME}"
log_info ""
log_info "Next steps:"
log_info "  1. Verify CI workflow runs: gh workflow list -R ${ORG}/${REPO_NAME}"
log_info "  2. Create initial release: git tag v1.0.0 && git push origin v1.0.0"
log_info "  3. Verify image in GHCR: gh run list -R ${ORG}/${REPO_NAME}"

# Cleanup
cd "${MONOREPO_ROOT}"
rm -rf "${WORK_DIR}/${REPO_NAME}"

echo ""
echo "Done!"
