require 'tk'
root = TkRoot.new { title "Ex1" }
TkLabel.new(root) do
  text 'Hello world!'
  pack {padx 15; pady 15; side 'left'}
end
Tk.mainloop
