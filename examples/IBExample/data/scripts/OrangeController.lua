waxClass{"OrangeController", UIViewController}

-- IBOutlet doesn't actually do anything, you'll need to 
IBOutlet 'button'
IBOutlet 'textField'

function init(self)
  self.super:initWithNibName_bundle("OrangeView", nil)

  return self
end

function viewDidLoad(self)
  self.button:addTarget_action_forControlEvents(self, "buttonTouched:", UIControlEventTouchUpInside) 
  self.textField:setText("This was also created in Lua!")
end

function buttonTouched(self, sender)
  self:view():superview():addSubview(blueController:view())
  self:view():removeFromSuperview()
end
