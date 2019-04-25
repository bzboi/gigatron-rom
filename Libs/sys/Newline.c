
#include <Gigatron.h>

void Newline(void)
{
  // TODO Scroll up screen when needed (using videoTable)

  // Go down 8..15 pixels, realigning at 8 pixel rows, and indent
  _ScreenPos = ((_ScreenPos + 0x0700) & 0xf800) + (0x0800 + _Indent);

  if (_ScreenPos < 0)
    _ScreenPos = (int)screenMemory + _Indent; // Wrap around
}

