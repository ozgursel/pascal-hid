# Ubuntu & Debian Lazarus Kurulumu
Lazarus Kurulumu için
https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.0.8/ 
adresinden ilgili 3 adet .deb paketini indirin bunlar...

-> lazarus-project_2.0.8-0_amd64.deb
-> fpc-src_3.0.4-2_amd64.deb
-> fpc-laz_3.0.4-1_amd64.deb

Sonra paketlerin indirildiği dizine giderek terminale sırasıyla ilgili komutları yazın
    
    sudo dpkg -i fpc-src_3.0.4-2_amd64.deb
    sudo dpkg -i fpc-laz_3.0.4-1_amd64.deb
    sudo dpkg -i lazarus-project_2.0.8-0_amd64.deb

önce fpc-* paketlerinin kurulumu yapılmalı en sonunda  lazarus-project_2.0.8-0_amd64.deb paketi kurulmalı.


## Linux İçin İlgili HID kütüphanesinin Kurulumu
Aşşağıdaki komutu terminale girerek kütüphaneyi indir.
https://packages.debian.org/sid/libhidapi-dev adresinden manuel olarak indirebilirsiniz fakat. aşşağıdaki komut otomatik olarak yükleyecektir.
    
    sudo apt-get install libhidapi-dev
    
## Örnek Kullanım

Öncelikle Cihazın VendorId'si ve ProductID'sinin tespit edilmesi gerekiyor, aşşağıdadki komut bağlı usb cihazlarının listesini döndürür...
    
    lsusb
    
Veya cihazı bilgisayara çıkartıp taktıktan hemen sonra aşşağıdaki komutla cihazın ilgili bilgileri bulunabilir.

    dmesg 

komutu ile son takılan cihazın bilgilerine ulaşabilirsiniz

### Örnek Kod
    
    // Burada ilgili VendorID ve ProductID değerleri DEMO Sabitleriyle değiştirilir.
    const
        DEMO_VID = $16d0;
        DEMO_PID = $0949;

    var
        Device: PHidDevice;
        I, J, Num: Integer;
        Buffer: array[0..63] of Byte;

    begin
        WriteLn(Format('Cihaza Bağlanıyor %0.4x:%0.4x', [DEMO_VID, DEMO_PID]));
        WriteLn();
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
    
hidapi.pas kodlarında kütüphane fonksiyonları, örnek uygulama ise demo dosyalarında mevcut

## Demo'yu Çalıştırma
Uygulama derlendikten sonra
Cihaza Erişebilmek için ilgili izinlerin verilmesi gerekiyor. 
İzinler için kalıcı değişiklik sağlamak adına udev kurallarının değiştirilmesi gerekiyor (burası daha sonra Production ortamında.. test için gerekli değil..)

Basitce ilk test için aşşağıdaki komut izinlerin verilmesi için yeterli olacaktır.

    sudo chmod 777 /dev/hidraw4

Sonra direkt olarak programı admin olarak çalıştırın.

    sudo ./demo
    





