// @flow

import React from 'react'
import {
  SortableContainer,
  SortableElement,
  SortableHandle,
  arrayMove
} from 'react-sortable-hoc'
import { PolicyTile } from 'Policies/components/PolicyTile'

import type { ThunkAction, ChainPolicy } from 'Policies/types'
import type { SortPolicyChainAction } from 'Policies/actions/PolicyChain'

type Props = {
  chain: Array<ChainPolicy>,
  actions: {
    openPolicyRegistry: () => ThunkAction,
    editPolicy: (ChainPolicy, number) => ThunkAction,
    sortPolicyChain: (Array<ChainPolicy>) => SortPolicyChainAction
  }
}

const DragHandle = SortableHandle(() => <div className="Policy-sortHandle"><i className="fa fa-sort" /></div>)

const SortableItem = SortableElement(({value, editPolicy, index}) => {
  const edit = () => editPolicy(value, index)
  return (
    <li className={ value.enabled ? 'Policy' : 'Policy Policy--disabled' }>
      <PolicyTile policy={value} onClick={edit} />
      <DragHandle/>
    </li>
  )
})

const SortableList = SortableContainer(({ items, editPolicy }) => {
  return (
    <ul className="list-group">
      {items.map((policy, index) => (
        <SortableItem
          key={`item-${index}`}
          index={index}
          value={policy}
          editPolicy={editPolicy}
        />
      ))}
    </ul>
  )
})

const AddPolicyButton = ({openPolicyRegistry}: {openPolicyRegistry: () => ThunkAction}) => {
  return (
    <div className="PolicyChain-addPolicy" onClick={openPolicyRegistry}>
      <i className="fa fa-plus-circle" /> Add Policy
    </div>
  )
}

const PolicyChain = ({chain, actions}: Props) => {
  const onSortEnd = ({oldIndex, newIndex}) => {
    const sortedChain = arrayMove(chain, oldIndex, newIndex)
    actions.sortPolicyChain(sortedChain)
  }

  return (
    <section className="PolicyChain">
      <header className="PolicyChain-header">
        <h2 className="PolicyChain-title">Policy Chain</h2>
        <AddPolicyButton openPolicyRegistry={actions.openPolicyRegistry} />
      </header>
      <SortableList
        items={chain}
        onSortEnd={onSortEnd}
        useDragHandle={true}
        editPolicy={actions.editPolicy}
      />
    </section>
  )
}

export {
  PolicyChain,
  SortableList,
  SortableItem,
  AddPolicyButton,
  DragHandle
}
