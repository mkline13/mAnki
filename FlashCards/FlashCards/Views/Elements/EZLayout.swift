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
    
    // MARK: - ADD VIEW
    func addArrangedSubview(_ view: UIView, spacing: CGFloat? = nil) {
        if let finalConstraint = finalConstraint {
            content.removeConstraint(finalConstraint)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        if debugMode {
            spacer.backgroundColor = .systemBlue
            view.backgroundColor = .systemRed
        }
        
        content.addSubview(spacer)
        content.addSubview(view)
        
        // Add constraints
        if let previousView = previousView {
            content.addConstraint(view.topAnchor.constraint(equalTo: previousView.bottomAnchor))
        }
        else {
            content.addConstraint(view.topAnchor.constraint(equalTo: content.topAnchor))
        }
        
        content.addConstraints([
            view.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            
            spacer.topAnchor.constraint(equalTo: view.bottomAnchor),
            spacer.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: spacing ?? defaultSpacing),
        ])
        
        previousView = spacer
        
        finalConstraint = spacer.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        content.addConstraint(finalConstraint!)
    }
    
    func addSeparator(spacing: CGFloat? = nil) {
        if let finalConstraint = finalConstraint {
            content.removeConstraint(finalConstraint)
        }
        
        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        if debugMode {
            spacer.backgroundColor = .systemBlue
            separator.backgroundColor = .magenta
        }
        
        content.addSubview(spacer)
        content.addSubview(separator)
        
        // Add constraints
        if let previousView = previousView {
            content.addConstraint(separator.topAnchor.constraint(equalTo: previousView.bottomAnchor))
        }
        else {
            content.addConstraint(separator.topAnchor.constraint(equalTo: content.topAnchor))
        }
        
        content.addConstraints([
            separator.centerXAnchor.constraint(equalTo: content.centerXAnchor),
            separator.widthAnchor.constraint(equalTo: content.layoutMarginsGuide.widthAnchor, multiplier: 1.0),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            spacer.topAnchor.constraint(equalTo: separator.bottomAnchor),
            spacer.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: spacing ?? defaultSpacing),
        ])
        
        previousView = spacer
        
        finalConstraint = spacer.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        content.addConstraint(finalConstraint!)
    }
    
    func addSpacer(height: CGFloat? = nil) {
        if let finalConstraint = finalConstraint {
            content.removeConstraint(finalConstraint)
        }
                
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        if debugMode {
            spacer.backgroundColor = .systemBlue
        }
        
        content.addSubview(spacer)
        if let previousView = previousView {
            content.addConstraint(spacer.topAnchor.constraint(equalTo: previousView.bottomAnchor))
        }
        else {
            content.addConstraint(spacer.topAnchor.constraint(equalTo: content.topAnchor))
        }
        
        content.addConstraints([
            spacer.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: height ?? defaultSpacing),
        ])
        
        previousView = spacer
        
        finalConstraint = spacer.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        content.addConstraint(finalConstraint!)
    }
    
    // MARK: Properties
    var debugMode: Bool = false
    private let defaultSpacing: CGFloat
    
    private var content: UIView!
    private var previousView: UIView?
    private var finalConstraint: NSLayoutConstraint?
}
