// @flow

import { DefaultPlanSelectWrapper } from 'Plans/components/DefaultPlanSelectCard'
import { safeFromJsonString } from 'utilities'

import type { Record } from 'Types'

document.addEventListener('DOMContentLoaded', () => {
  const containerId = 'default_plan'
  const container = document.getElementById(containerId)

  if (!container) {
    return
  }

  const { dataset } = container
  const plans = safeFromJsonString<Record[]>(dataset.plans) || []
  const initialDefaultPlan = safeFromJsonString<Record>(dataset.currentPlan) || null
  const path: string = dataset.path

  DefaultPlanSelectWrapper({
    initialDefaultPlan,
    plans: plans,
    path
  }, containerId)
})
