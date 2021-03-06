
final class SectionHeader: NSTableRowView {

	var titleView: CenterTextField!

	init(title: String, showRemoveAllButton: Bool) {

		let titleHeight: CGFloat = 42

		super.init(frame: NSMakeRect(0, 0, MENU_WIDTH, titleHeight))

		let W = MENU_WIDTH - app.scrollBarWidth
		if showRemoveAllButton {
			let buttonRect = NSMakeRect(W-100, 5, 90, titleHeight)
			let unpin = NSButton(frame: buttonRect)
			unpin.title = "Remove All"
			unpin.target = self
			unpin.action = #selector(unPinSelected)
			unpin.setButtonType(.momentaryLight)
			unpin.bezelStyle = .roundRect
			unpin.font = NSFont.systemFont(ofSize: 10)
			addSubview(unpin)
		}

		let x = W-120-AVATAR_SIZE-LEFTPADDING
		titleView = CenterTextField(frame: NSMakeRect(12, 4, x, titleHeight))
		titleView.attributedStringValue = NSAttributedString(string: title, attributes: [
				NSFontAttributeName: NSFont.boldSystemFont(ofSize: 14),
				NSForegroundColorAttributeName: NSColor.controlShadowColor.withAlphaComponent(0.7)])
		addSubview(titleView)
	}

	func unPinSelected() {
		app.removeSelected(on: titleView.attributedStringValue.string)
	}

	required init?(coder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
