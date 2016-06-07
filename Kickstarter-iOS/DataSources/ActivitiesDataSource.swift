import Library
import KsApi
import UIKit

internal final class ActivitiesDataSource: ValueCellDataSource {

  private enum Section: Int {
    case EmptyState
    case Activities
  }

  internal func emptyState(visible visible: Bool) {
    self.set(values: visible ? [()] : [],
             cellClass: ActivityEmptyStateCell.self,
             inSection: Section.EmptyState.rawValue)
  }

  internal func load(activities activities: [Activity]) {
    let section = Section.Activities.rawValue

    self.clearValues(section: section)

    activities.forEach { activity in
      switch activity.category {
      case .backing:
        self.appendRow(value: activity, cellClass: ActivityFriendBackingCell.self, toSection: section)
      case .update:
        self.appendRow(value: activity, cellClass: ActivityUpdateCell.self, toSection: section)
      case .follow:
        self.appendRow(value: activity, cellClass: ActivityFriendFollowCell.self, toSection: section)
      case .success:
        self.appendRow(value: activity, cellClass: ActivitySuccessCell.self, toSection: section)
      case .failure, .cancellation, .suspension:
        self.appendRow(value: activity, cellClass: ActivityNegativeStateChangeCell.self, toSection: section)
      case .launch:
        self.appendRow(value: activity, cellClass: ActivityLaunchCell.self, toSection: section)
      default:
        assertionFailure("Unsupported activity: \(activity)")
      }

      self.appendStaticRow(cellIdentifier: "Padding", toSection: section)
    }
  }

  override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {

    switch (cell, value) {
    case let (cell as ActivityUpdateCell, activity as Activity):
      cell.configureWith(value: activity)
    case let (cell as ActivityFriendBackingCell, activity as Activity):
      cell.configureWith(value: activity)
    case let (cell as ActivityFriendFollowCell, activity as Activity):
      cell.configureWith(value: activity)
    case let (cell as ActivitySuccessCell, activity as Activity):
      cell.configureWith(value: activity)
    case let (cell as ActivityNegativeStateChangeCell, value as Activity):
      cell.configureWith(value: value)
    case let (cell as ActivityLaunchCell, value as Activity):
      cell.configureWith(value: value)
    case let (cell as ActivityEmptyStateCell, value as Void):
      cell.configureWith(value: value)
    case (is StaticTableViewCell, is Void):
      return
    default:
      assertionFailure("Unrecognized combo: \(cell), \(value)")
    }
  }
}
