// @flow

import { ChangePlanSelectCardWrapper } from 'Plans/components/ChangePlanSelectCard'
import { safeFromJsonString } from 'utilities'

import type { Record } from 'Types'

document.addEventListener('DOMContentLoaded', () => {
  const containerId = 'change_plan_select'
  const container = document.getElementById(containerId)

  if (!container) {
    return
  }

  const { dataset } = container
  const applicationPlans = safeFromJsonString<Record[]>(dataset.applicationPlans) || []
  const path: string = dataset.path

  ChangePlanSelectCardWrapper({
    applicationPlans,
    path
  }, containerId)
})
