
#include <Crypt.au3>

$bananas = _Crypt_HashData("superfarts",$CALG_SHA1)
ConsoleWrite(@CRLF & $bananas & @CRLF)