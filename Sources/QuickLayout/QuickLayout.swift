import UIKit

extension UIView {

    indirect enum ConstraintConfiguration {
        case fill(_ inset: UIEdgeInsets = .init())
        case center
        case verticalFill(_ inset: UIEdgeInsets = .init())
        case horizontalFill(_ inset: UIEdgeInsets = .init())

        /// Merge multiple ConstraintConfiguration.
        case multiple(_ types: [ConstraintConfiguration])

        /// Configure the view to the parent manually.
        case custom(_ configure: (UIView) -> Void)
    }

    func layout(in view: UIView, config: ConstraintConfiguration) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        switch config {
        case .fill(let inset):
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
                topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom),
            ])
        case .center:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        case .multiple(let types):
            types
                .map { (view, $0) }
                .forEach(layout)
        case .verticalFill(let inset):
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom),
            ])
        case .horizontalFill(let inset):
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right)
            ])
        case .custom(let config):
            config(view)
        }
    }
}

extension UIEdgeInsets {
    static var vertical: (CGFloat) -> UIEdgeInsets = { UIEdgeInsets(top: $0, left: 0, bottom: $0, right: 0) }
    static var horizontal: (CGFloat) -> UIEdgeInsets = { UIEdgeInsets(top: 0, left: $0, bottom: 0, right: $0) }
    static var just: (CGFloat) -> UIEdgeInsets = { UIEdgeInsets(top: $0, left: $0, bottom: $0, right: $0) }
}

public extension UIStackView {

    /// Convinient builder for creating StackViews in one line.
    static func create(
        _ axis: NSLayoutConstraint.Axis,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: CGFloat = 0,
        arrangedSubviews: [UIView] = []
    ) -> Self {
        let view = Self(arrangedSubviews: arrangedSubviews)

        view.axis = axis
        view.alignment = alignment
        view.distribution = distribution
        view.spacing = spacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
}
