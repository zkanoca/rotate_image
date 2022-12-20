function resim_don = resmiDondur(da_deg, resim_org)
    
    %derece olarak verilen d�nd�rme a��s�n� radyana d�n��t�r
    da_rad = da_deg*pi/180;

    %Rotation matrisi olu�tur
    R = [+cos(da_rad) +sin(da_rad); -sin(da_rad) +cos(da_rad)];

    %d�nd�r�lm�� resmin boyutunu hesapla
    % e: en, b:boy, d: renk derinli�i (RGB)
    [e,b,d] = size(resim_org);

    %d�nd�r�lecek resim i�in alan boyutunu belirle 
    %koordinatlar tamsay� olmas� i�in round() fonk. kull. 
    drAlan = round([1 1; 1 b; e 1; e b]*R);

    %her s�tundaki en k���k de�eri o s�tundaki b�t�n elemanlardan ��kar
    %daha sonra 1 ekle
    %bu sayede d�nd�r�lm�� resmin boyutlar� belirlenmi� olur
    drAlan = bsxfun(@minus, drAlan, min(drAlan)) + 1;

    %dondurulmu� zemin i�in siyah alan olu�tur.
    %p resmin renk boyutudur. 
    %class() fonksiyonu ile d�nd�r�lm�� resmin orijinal resimle 
    %ayn� t�rde veri tutmalar� sa�lan�r.
    resim_don = zeros([max(drAlan) d],class(resim_org));

    %her bir pikselin yeni koordinat�n� hesaplamak i�in d�ng� i�inde i�lem
    %yap
    for r = 1:size(resim_don,1)
        for c = 1:size(resim_don,2)
            
            %orijinal resimde ilgili pikseli al ve yeni koordinat� bul
            yk = ([r c]-drAlan(1,:)) * R.';

            %e�er kaynak resim s�n�rlar� i�indeyse
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