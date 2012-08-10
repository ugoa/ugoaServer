require 'tk'
root = TkRoot.new { title "Ex2"}
top = TkFrame.new(root) {relief 'raised'; border 5}

lbl = TkLabel.new(top) do
  justify 'center'
  text 'I rock.'
  pack('padx' => 5, 'pady' => 5, 'side' => 'top')
end

TkButton.new(top) do
  text "Ok"
  command {exit}
  pack('side' => 'left', 'padx' => 10, 'pady' => 10)
end

TkButton.new(top) do
  text 'Cancel'
  command { lbl.configure('text' => "Goodbye, Cruel World!")}
  pack('side' => 'right', 'padx' => 10, 'pady' => 10)
end

top.pack('fill' => 'both', 'side' => 'top')
Tk.mainloop
