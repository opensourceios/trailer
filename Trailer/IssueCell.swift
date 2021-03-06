
final class IssueCell: TrailerCell {

	init(issue: Issue) {

		super.init(frame: NSZeroRect, item: issue)

		let _commentsNew = issue.unreadComments
		let _commentsTotal = issue.totalComments

		let _title = issue.title(with: titleFont, labelFont: detailFont, titleColor: unselectedTitleColor)
		let _subtitle = issue.subtitle(with: detailFont, lightColor: .gray, darkColor: .darkGray)

		var W = MENU_WIDTH-LEFTPADDING-app.scrollBarWidth

		let showUnpin = issue.condition != ItemCondition.open.rawValue
		if showUnpin { W -= REMOVE_BUTTON_WIDTH } else { W -= 4.0 }

		let showAvatar = !S(issue.userAvatarUrl).isEmpty && !Settings.hideAvatars
		if showAvatar { W -= AVATAR_SIZE+AVATAR_PADDING } else { W += 4.0 }

		let titleHeight = ceil(_title.boundingRect(with: CGSize(width: W-4.0, height: .greatestFiniteMagnitude), options: stringDrawingOptions).size.height)
		let subtitleHeight = ceil(_subtitle.boundingRect(with: CGSize(width: W-4.0, height: .greatestFiniteMagnitude), options: stringDrawingOptions).size.height+4.0)

		var bottom: CGFloat
		let cellPadding: CGFloat = 6.0

		bottom = ceil(cellPadding * 0.5)

		frame = NSMakeRect(0, 0, MENU_WIDTH, titleHeight+subtitleHeight + cellPadding)
		let faded = issue.shouldSkipNotifications
		addCounts(_commentsTotal, _commentsNew, faded)

		var titleRect = NSMakeRect(LEFTPADDING, subtitleHeight+bottom, W, titleHeight)
		var dateRect = NSMakeRect(LEFTPADDING, bottom, W, subtitleHeight)
		var pinRect = NSMakeRect(LEFTPADDING+W, floor((bounds.size.height-24)*0.5), REMOVE_BUTTON_WIDTH-10, 24)

		var shift: CGFloat = -4
		if showAvatar {
			let userImage = AvatarView(
				frame: NSMakeRect(LEFTPADDING, bounds.size.height-AVATAR_SIZE-7.0, AVATAR_SIZE, AVATAR_SIZE),
				url: S(issue.userAvatarUrl))
			if faded { userImage.alphaValue = DISABLED_FADE }
			addSubview(userImage)
			shift = AVATAR_PADDING+AVATAR_SIZE
		}
		pinRect = NSOffsetRect(pinRect, shift, 0)
		dateRect = NSOffsetRect(dateRect, shift, 0)
		titleRect = NSOffsetRect(titleRect, shift, 0)

		if showUnpin {
			if issue.condition == ItemCondition.open.rawValue {
				let unmergeableLabel = CenterTextField(frame: pinRect)
				unmergeableLabel.textColor = .red
				unmergeableLabel.font = NSFont(name: "Monaco", size: 8.0)
				unmergeableLabel.alignment = .center
				unmergeableLabel.stringValue = "Cannot be merged"
				addSubview(unmergeableLabel)
			} else {
				let unpin = NSButton(frame: pinRect)
				unpin.title = "Remove"
				unpin.target = self
				unpin.action = #selector(unPinSelected)
				unpin.setButtonType(.momentaryLight)
				unpin.bezelStyle = .roundRect
				unpin.font = NSFont.systemFont(ofSize: 10.0)
				addSubview(unpin)
			}
		}

		title = CenterTextField(frame: titleRect)
		title.attributedStringValue = _title
		addSubview(title)

		let subtitle = CenterTextField(frame: dateRect)
		subtitle.attributedStringValue = _subtitle
		addSubview(subtitle)

		if faded {
			title.alphaValue = DISABLED_FADE
			subtitle.alphaValue = DISABLED_FADE
		}

		updateMenu()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
