function resim_don = resmiDondur(da_deg, resim_org)
    
    %derece olarak verilen döndürme açýsýný radyana dönüþtür
    da_rad = da_deg*pi/180;

    %Rotation matrisi oluþtur
    R = [+cos(da_rad) +sin(da_rad); -sin(da_rad) +cos(da_rad)];

    %döndürülmüþ resmin boyutunu hesapla
    % e: en, b:boy, d: renk derinliði (RGB)
    [e,b,d] = size(resim_org);

    %döndürülecek resim için alan boyutunu belirle 
    %koordinatlar tamsayý olmasý için round() fonk. kull. 
    drAlan = round([1 1; 1 b; e 1; e b]*R);

    %her sütundaki en küçük deðeri o sütundaki bütün elemanlardan çýkar
    %daha sonra 1 ekle
    %bu sayede döndürülmüþ resmin boyutlarý belirlenmiþ olur
    drAlan = bsxfun(@minus, drAlan, min(drAlan)) + 1;

    %dondurulmuþ zemin için siyah alan oluþtur.
    %p resmin renk boyutudur. 
    %class() fonksiyonu ile döndürülmüþ resmin orijinal resimle 
    %ayný türde veri tutmalarý saðlanýr.
    resim_don = zeros([max(drAlan) d],class(resim_org));

    %her bir pikselin yeni koordinatýný hesaplamak için döngü içinde iþlem
    %yap
    for r = 1:size(resim_don,1)
        for c = 1:size(resim_don,2)
            
            %orijinal resimde ilgili pikseli al ve yeni koordinatý bul
            yk = ([r c]-drAlan(1,:)) * R.';

            %eðer kaynak resim sýnýrlarý içindeyse
            if all(yk >= 1) && all(yk <= [e b]);

                %
                tavan = ceil(yk);
                
                taban = floor(yk);

                %
                A = [...
                    ((tavan(2)-yk(2))*(tavan(1)-yk(1))),...
                    ((yk(2)-taban(2))*(yk(1)-taban(1)));
                    ((tavan(2)-yk(2))*(yk(1)-taban(1))),...
                    ((yk(2)-taban(2))*(tavan(1)-yk(1)))];

                % .
                cols = bsxfun(@times, A, ...
                    double(resim_org(taban(1):tavan(1),...
                                     taban(2):tavan(2),...
                                     :)...
                                    )...
                          );

                %                      
                resim_don(r,c,:) = sum(sum(cols),2);
            end
        end
    end  
end