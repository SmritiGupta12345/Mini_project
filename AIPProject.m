I=imread('cameraman.tif');
[rows cols]=size(I);
I1=I;
%% Histogram array
H=zeros(256,1);
for p=0 : 255
H(p+1)=numel(find(I==p));      
end
%End of Histogram array
M=0;
for p=1:255
    M=M+H(p);
end
for p=0:255
    h(p+1)=H(p+1)/M;
end
s=0;
for p=0:255
    s=s+h(p+1);
end
% display(s);
Im=0;
for p=0:255
    Im=Im+h(p+1)*(p+1);
end
% display(Im);
for x=0:255
    for y=0:255
        if I(x+1,y+1)>Im
            Ih(x+1,y+1)=I(x+1,y+1);
        end
        if I(x+1,y+1)<=Im
            Il(x+1,y+1)=I(x+1,y+1);
        end
    end
end
%% Histogram array
Hl=zeros(256,1);
for p=0 : round(Im-1)
Hl(p+1)=numel(find(Il==p));     
end
%End of Histogram array
%% Histogram array
Hh=zeros(256,1);
for p=round(Im) : 255
Hh(p+1)=numel(find(Ih==p));      
end
%End of Histogram array
nlp=Hl;
nhp=Hh;
Nl=0; Nh=0;
for p=0:round(Im-1)
    Nl=Nl+nlp(p+1);
end
for p=round(Im):255
    Nh=Nh+nhp(p+1);
end
% display(Nl);
% display(Nh);
Y=0.01;
CLl=ceil(Nl/round(Im+1))+round(Y*(Nl-(Nl/round(Im+1))));
CLh=ceil(Nh/round(255-Im))+round(Y*(Nh-(Nh/round(255-Im))));
% display(CLl);
% display(CLh);
Tl=0;Th=0;
for k=0:round(Im)
Tl=Tl+max(Hl(k+1)-CLl,0);      
end
for k=round(Im):255
Th=Th+max(Hh(k+1)-CLh,0);      
end
% display(Tl);
% display(Th)
AIl=floor(Tl/(round(Im)+1));
AIh=floor(Th/(255-1-round(Im)));
% display(AIl);
% display(AIh);
for p=0:round(Im)-1
    if Hl(p+1)>(CLl-AIl)
    W(p+1)=CLl;
    else
        W(p+1)=Hl(p+1)+AIl;
    end
end
for p=round(Im):255
    if Hh(p+1)>(CLh-AIh)
    V(p+1)=CLh;
    else
        V(p+1)=Hh(p+1)+AIh;
    end
end

% %% Histogram array

 H5=cat(2,W,V);
 for i=round(Im):length(H5)
     if H5(1:256)==0
         H5(i)=[];
     end
 end
H5(121:240)=[];
% %End of Histogram array
%%Histogram Equlization
for p=0:round(Im)-1
A(p+1)=W(p+1)/Nl;      
end
for p=round(Im):255
B(p+1)=V(p+1)/Nh;      
end
%CDFs of Il and Ih
Cl=zeros(256,1);
for p=0:round(Im)-1
    for q=0:p
        Cl(p+2)=Cl(p+1)+A(q+1);
    end
end
Ch=zeros(256,1);
for p=round(Im):255
    for q=round(Im):p
        Ch(p+2)=Ch(p+1)+B(q+1);
    end
end
%%calculation of G
for p=0:round(Im)-1
    Gl(p+1)=round(Im)*Cl(p+1);
end
for p=round(Im):255
    Gh(p+1)=round(Im)+1+(254-round(Im))*Ch(p+1);
end
for x=1:length(Il)
    for y=1:length(Il)
        El(x,y)=Gl(Il(x,y)+1);
    end
end
for x=1:length(Il)
    for y=1:length(Il)
        Eh(x,y)=Gh(Ih(x,y)+1);
    end
end
%display(El);
%display(Eh);
E=El+Eh;
I2=Il+Ih;
%% Histogram array
%H2=zeros(256,1);
for p=0 : 255
H2(p+1)=numel(find(I2==p));      
end
%End of Histogram array
EH=zeros(256,1);
for p=0 : 255
EH(p+1)=numel(find(E==p));      
end
imtool(I,[]);
imtool(Il,[]);
imtool(Ih,[]);
imtool(I2,[]);
imtool(E,[]);
%% plots and figures
  figure(1);
  bar(H);
title('Histogram of Original Image');
figure(2);
bar(H5);
title('Clipped Histogram of Image');
 figure(3);
  bar(W);
 title('Clipped Histogram of Lower Intensity Image');
figure(4);
bar(V);
title('Clipped Histogram of Higher Intensity Image');
figure(5);
bar(EH);
title('Histogram of Enhanced Image');
