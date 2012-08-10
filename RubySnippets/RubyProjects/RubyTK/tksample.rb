require 'tk'

root = TkRoot.new { title "Ex1" }
TkLabel.new(root) do
  text 'Hello ruby.'
  pack { padx 5; pady 5; side 'left' }
end

TkLabel.new { text 'Hello, World!'; pack } # equal as the 'hello ruby' without specifing the root

TkLabel.new(root, 'text' => 'Hello, Tk.').pack('padx' => 5,
                                               'pady' => 5,
                                               'side' => 'left')

TkButton.new(root) do
  text 'EXIT'
  command { exit }
  pack('side' => 'left', 'padx' => 10, 'pady' => 10)
end

packing = { 'padx' => 5, 'pady' => 5, 'side' => 'left' }
checked = TkVariable.new
def checked.status
  value == '1' ? "Yes" : "No"
end

status = TkLabel.new(root) do
  text checked.status
  pack(packing)
end

TkCheckButton.new do
  variable checked
  pack(packing)
end

TkButton.new do
  text "Show status"
  command { status.text(checked.status) }
  pack(packing)
end

Tk.mainloop
