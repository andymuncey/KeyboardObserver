import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        view.backgroundColor = .gray
        
        //allows a tap on the background to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func ensureVisible(view: UITextField, obscuredHeight: CGFloat) {
        let frameInView = view.convert(view.bounds, to: self.view)
        let requiredOffset = self.view.frame.height - obscuredHeight
        
        if frameInView.maxY > requiredOffset {
            self.view.frame.origin.y = -(frameInView.maxY - requiredOffset + 10)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let activeView = view.currentFirstResponder as? UITextField
            else { return }

        ensureVisible(view: activeView, obscuredHeight: keyboardFrame.height)

    }
    
    @objc func keyboardWillHide(_ notification: Notification){
            view.frame.origin.y = 0
    }
    
    
}



extension UIView {
    
    /**
     Finds the view with focus (i.e. where the user is interacting)
     */
    var currentFirstResponder: UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.currentFirstResponder {
                return responder
            }
        }
        return nil
    }
}
