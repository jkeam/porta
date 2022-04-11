// @flow

import { QuickStartContainerWrapper as QuickStartContainer } from 'QuickStarts/components/QuickStartContainer'
import { getActiveQuickstart } from 'QuickStarts/utils/progressTracker'
import { safeFromJsonString } from 'utilities/json-utils'

document.addEventListener('DOMContentLoaded', () => {
  if (getActiveQuickstart == null) {
    return // No need to render Quickstarts
  }

  const containerId = 'quick-start-container'
  const container = document.getElementById(containerId)

  if (!container) {
    throw new Error(`Container not found: #${containerId}`)
  }

  const { links, renderCatalog } = container.dataset

  QuickStartContainer({
    links: safeFromJsonString<Array<[string, string, string]>>(links) || [],
    renderCatalog: safeFromJsonString<boolean>(renderCatalog)
  }, containerId)

  // HACK of the year: We need QuickStartContainer to wrap the whole #wrapper for the Drawer to work properly.
  const wrapperContainer = document.getElementById('wrapper')
  const quickStartsContainer = document.querySelector('.pfext-quick-start-drawer__body')

  if (wrapperContainer && quickStartsContainer) {
    quickStartsContainer.after(wrapperContainer)
  }
})
