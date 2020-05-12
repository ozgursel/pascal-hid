program cidlinux;


// 'sudo apt-get install libhidapi-dev' komutu gerekli hid kütüphanesini indirmek için!
// 'https://packages.debian.org/sid/libhidapi-dev'

// modeswitch
{$modeswitch autoderef}

uses
  sysutils, hidapi;


procedure EnumerationDemo;
var
  EnumList, EnumItem: PHidDeviceInfo;
  Path: String;
  Vid, Pid: Word;
  ProductName: UnicodeString;

begin
  WriteLn('Cihaza Erişebilmek için ilgili izinlerin verilmesi gerekiyor');
  WriteLn('İzinler için kalıcı değişiklik sağlamak adına udev kurallarının değiştirilmesi gerekiyor');
  WriteLn('Yada Basitce { sudo chmod 777 /dev/hidraw4 } komutuyla yada direkt olarak programı { sudo ./demo } olarak çalıştırın.');
  WriteLn();

  // hidapi'den bütün cihazların listesini getirir
  EnumList := THidDeviceInfo.Enumerate(0, 0);

  EnumItem := EnumList;
  while Assigned(EnumItem) do begin
    Path := EnumItem.Path;
    Vid := EnumItem.VendorID;
    Pid := EnumItem.ProductID;
    ProductName := PCWCharToUnicodeString(EnumItem.ProductString);
    WriteLn(Format('Found: %s (%0.4x:%0.4x) at: %s', [ProductName, Vid, Pid, Path]));
    EnumItem := EnumItem.Next;
  end;
  WriteLn();
  EnumList.Free;
end;


procedure OpenAndReadDemo;
const
  // Burada ilgili VendorID ve ProductID değerleri DEMO Sabitleriyle değiştirilir.
  DEMO_VID = $16d0;
  DEMO_PID = $0949;

var
  Device: PHidDevice;
  I, J, Num: Integer;
  Buffer: array[0..63] of Byte;

begin
  WriteLn(Format('Cihaza Bağlanıyor %0.4x:%0.4x', [DEMO_VID, DEMO_PID]));
  WriteLn();
  // Device := THidDevice.OpenPath('/dev/hidraw4'); direk path vererek bağlanmak için...
  Device := THidDevice.Open(DEMO_VID, DEMO_PID, '');
  if not Assigned(Device) then begin
    WriteLn('Cihaza Bağlanılamadı!');
    WriteLn('Doğru parametreleri girdiğinizden yada Cihaz izinlerini verdiğinizden emin olun')
  end
  else begin
    WriteLn('Cihaza Bağlanıldı!');
    WriteLn('Manufacturer: ', Device.GetManufacturerString);
    WriteLn('Product: ', Device.GetProductString);
    for I := 1 to 1000 do begin
      Num := Device.Read(Buffer, SizeOf(Buffer));
      for J := 0 to Num - 1 do begin
          Write(Format('%0.2x ', [Buffer[J]]));
      end;
      Write(#13);
    end;
    WriteLn();
    WriteLn('Cihaz Kapatılıyor.');
    Device.Close;
  end;
end;


begin
  EnumerationDemo;
  OpenAndReadDemo;
end.

