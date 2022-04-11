// @flow

/**
 * This is a collection of wrappers around localStorage to ease getting information about Quickstarts state
 */

function getActiveQuickstart (): null | string {
  const quickstartId: string = JSON.parse(localStorage.getItem('quickstartId') || '')

  return quickstartId.length ? quickstartId : null
}

export { getActiveQuickstart }
