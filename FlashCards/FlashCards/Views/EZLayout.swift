//
//  LayoutElements.swift
//  FlashCards
//
//  Created by Work on 8/12/22.
//

import UIKit


class EZLayout: UIView {
    init (spacing: CGFloat = 8) {
        self.defaultSpacing = spacing
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up scrollview
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        addSubview(scrollView)
        addConstraints([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        content = UIView(frame: .infinite)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(content)
        scrollView.addConstraints([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendView(_ view: UIView, spacing: CGFloat? = nil) {
        if let finalConstraint = finalConstraint {
            content.removeConstraint(finalConstraint)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(spacer)
        content.addSubview(view)
        if let previousView = previousView {
            content.addConstraints([
                view.topAnchor.constraint(equalTo: previousView.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            ])
        }
        else {
            content.addConstraints([
                view.topAnchor.constraint(equalTo: content.layoutMarginsGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            ])
        }
        
        content.addConstraints([
            spacer.topAnchor.constraint(equalTo: view.bottomAnchor),
            spacer.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: spacing ?? defaultSpacing),
        ])
        
        previousView = spacer
        
        finalConstraint = spacer.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        content.addConstraint(finalConstraint!)
    }
    
    func finish() {
        guard let previousView = previousView else {
            return
        }
        
        content.addConstraints([
            previousView.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        ])
    }
    
    // MARK: Properties
    private let defaultSpacing: CGFloat
    
    private var content: UIView!
    private var previousView: UIView?
    private var finalConstraint: NSLayoutConstraint?
}
