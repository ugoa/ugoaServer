require 'tk'

image1 = TkPhotoImage.new { file "imga.GIF"}
image2 = TkPhotoImage.new { file "imgb.GIF"}

b = TkButton.new (@root) do
  image image1
  command { exit }
#  pack('side' => 'top', 'padx' => 10, 'pady' => 10)
  pack
end

b.bind("Enter") { b.configure('image' => image2) }
b.bind("Leave") { b.configure('image' => image1) }

Tk.mainloop
