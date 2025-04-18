clear all;
close all;
clc;

%segmentasi
n=100;
e_1=4*8.854*(10^(-12));
e_2=e_1/4;
x=zeros(n+1,1);
for i=1:n+1
    x(i)=-10+(i-1)*20/n;
end
y=-x;
%{
matrix1=zeros(n+1,n+1);
for i=1:n+1
    for j=1:n+1
        if (x(i))^2+(y(j))^2<=100
            matrix1(i,j)=1
        else
            matrix1(i,j)=0
        end
    end
end
%}
matrix=zeros(n+1,n+1);
for i=1:n+1
    for j=1:n+1
        if x(j)<=2 && x(j)>=-2 && y(i)==0
            matrix(i,j)=-1;
        elseif ((x(j))^2+(y(i))^2<=(100) && (x(j))^2+(y(i))^2>(10-20/n)^2)
            matrix(i,j)=1;
        end
    end
end
sum=0;
matrix2=zeros(n+1,n+1);
for i=1:n+1
    for j=1:n+1
        if ((x(j))^2+(y(i))^2<=(10-20/n)^2) && not(x(j)<=2 && x(j)>=-2 && y(i)==0)
            sum=sum+1;
            matrix2(i,j)=sum;
        end
    end
end
matrix3=zeros(sum,sum);
matrix4=zeros(sum,1);
baris=0;
%isi matriks persamaan
for i=1:n
    for j=1:n
        if ((x(j))^2+(y(i))^2<=(10-20/n)^2) && not(x(j)<=2 && x(j)>=-2 && y(i)==0)
            baris=baris+1;
            if matrix2(i-1,j)~= 0 && matrix2(i,j-1)~=0 && matrix2(i+1,j)~=0 && matrix2(i,j+1)~=0  
                if x(j)>0 && x(j)<10 && y(i)==0
                    matrix3(baris,matrix2(i-1,j))=2*e_1;
                    matrix3(baris,matrix2(i+1,j))=2*e_2;
                    matrix3(baris,matrix2(i,j+1))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j-1))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                elseif y(i)>0 && y(i)<10 && x(j)==0
                    matrix3(baris,matrix2(i,j-1))=2*e_2;
                    matrix3(baris,matrix2(i,j+1))=2*e_1;
                    matrix3(baris,matrix2(i-1,j))=(e_1+e_2);
                    matrix3(baris,matrix2(i+1,j))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                elseif y(i)==0 && x(j)==0
                    matrix3(baris,matrix2(i,j-1))= (e_1+e_2) ;
                    matrix3(baris,matrix2(i,j+1))= 2*e_1 ;
                    matrix3(baris,matrix2(i+1,j))= (e_1+e_2) ;
                    matrix3(baris,matrix2(i-1,j))= 2*e_1 ;
                    matrix3(baris,matrix2(i,j))= 2*(2*e_1 + e_2) ;
                else
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                end
            else
                
                %Ketika ujungnya 1 V
                if matrix(i,j-1)==1 && matrix(i,j+1)==1 && matrix(i-1,j)==1 && matrix2(i+1,j)~=0 %atas, kiri, kanan
                    matrix3(baris,matrix2(i+1,j))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                    matrix4(matrix2(i,j),1)=-2*e_2*matrix(i,j-1)-(e_1+e_2)*matrix(i-1,j)-2*e_1*matrix(i,j+1);
                elseif matrix(i,j-1)==1 && matrix(i,j+1)==1 && matrix(i+1,j)==1 && matrix2(i-1,j)~=0 %bawah, kiri, kanan
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j-1)-1*matrix(i+1,j)-1*matrix(i,j+1);
                elseif matrix(i,j-1)==1 && matrix(i-1,j)==1 && matrix(i+1,j)==1 && matrix2(i,j+1)~= 0 %kiri, atas, bawah
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j-1)-1*matrix(i+1,j)-1*matrix(i-1,j);
                elseif matrix(i,j+1)==1 && matrix(i-1,j)==1 && matrix(i+1,j)==1 && matrix2(i,j-1)~=0 %kanan, atas, bawah
                    matrix3(baris,matrix2(i,j-1))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                    matrix4(matrix2(i,j),1)=-2*e_2*matrix(i-1,j)-2*e_1*matrix(i+1,j)-(e_1+e_2)*matrix(i,j+1);
                elseif matrix(i-1,j)==1 && matrix(i,j-1)==1 && matrix2(i,j+1)~=0 && matrix2(i+1,j)~=0 %atas, kiri
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j-1)-1*matrix(i-1,j);
                elseif matrix(i-1,j)==1 && matrix(i,j+1)==1 && matrix2(i,j-1)~=0 && matrix2(i+1,j)~=0 %atas, kanan
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i-1,j)-1*matrix(i,j+1);
                elseif matrix(i,j+1)==1 && matrix(i+1,j)==1 && matrix2(i,j-1)~=0 && matrix2(i-1,j)~=0 %bawah, kanan
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j+1)-1*matrix(i+1,j);
                elseif matrix(i,j-1)==1 && matrix(i+1,j)==1 && matrix2(i,j+1)~=0 && matrix2(i-1,j)~=0 %bawah, kiri
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j-1)-1*matrix(i+1,j);
                elseif matrix(i,j-1)==1 && matrix2(i,j+1)~=0 && matrix2(i-1,j)~=0 && matrix2(i+1,j)~=0 %kiri
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j-1);
                elseif matrix(i,j+1)==1 && matrix2(i,j-1)~=0 && matrix2(i-1,j)~=0 && matrix2(i+1,j)~=0 %kanan
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j+1);
                elseif matrix(i-1,j)==1 && matrix2(i,j-1)~=0 && matrix2(i,j+1)~=0 && matrix2(i+1,j)~=0 %atas
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i-1,j);
                elseif matrix(i+1,j)==1 && matrix2(i,j-1)~=0 && matrix2(i,j+1)~=0 && matrix2(i-1,j)~=0 %bawah
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i+1,j);
                    
                %Ketika ujungnya -1 V    
                elseif matrix(i,j-1)==-1 && matrix2(i,j+1)~=0 && matrix2(i-1,j)~=0 && matrix2(i+1,j)~=0 %kiri
                    matrix3(baris,matrix2(i-1,j))=2*e_1;
                    matrix3(baris,matrix2(i+1,j))=2*e_2;
                    matrix3(baris,matrix2(i,j+1))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                    matrix4(matrix2(i,j),1)=-1*(e_1+e_2)*matrix(i,j-1);
                elseif matrix(i,j+1)==-1 && matrix2(i,j-1)~=0 && matrix2(i-1,j)~=0 && matrix2(i+1,j)~=0 %kanan
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i-1,j))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i,j+1);
                elseif matrix(i-1,j)==-1 && matrix2(i,j-1)~=0 && matrix2(i,j+1)~=0 && matrix2(i+1,j)~=0 %atas
                    matrix3(baris,matrix2(i,j))=-4;
                    matrix3(baris,matrix2(i,j-1))=1;
                    matrix3(baris,matrix2(i,j+1))=1;
                    matrix3(baris,matrix2(i+1,j))=1;
                    matrix4(matrix2(i,j),1)=-1*matrix(i-1,j);
                elseif matrix(i+1,j)==-1 && matrix2(i,j-1)~=0 && matrix2(i,j+1)~=0 && matrix2(i-1,j)~=0 %bawah
                    matrix3(baris,matrix2(i,j-1))=2*e_2;
                    matrix3(baris,matrix2(i,j+1))=2*e_1;
                    matrix3(baris,matrix2(i-1,j))=(e_1+e_2);
                    matrix3(baris,matrix2(i,j))=-4*(e_1+e_2);
                    matrix4(matrix2(i,j),1)=-(e_1+e_2)*matrix(i+1,j);
                end
            end
        end
    end
end

matrix5=inv(matrix3)*matrix4;
matrix6=matrix;
sum=0;
for i=1:n+1
    for j=1:n+1
        if ((x(j))^2+(y(i))^2<=(10-20/n)^2) && not(x(j)<=2 && x(j)>=-2 && y(i)==0)
            sum=sum+1;
            matrix6(i,j)=matrix5(sum,1);
        end
    end
end

%mencari -q
q=0;
for i=1:n
    for j=1:n
        if i==((n/2)+1)-(n/10)-1 && j>=((n/2)+1-(n/10)-1) && j<=((n/2)+1+(n/10)+1) %atas
            if j==(n/2)+1
                q=q+(matrix6(i-1,j)-matrix6(i+1,j))*(e_1+e_2)/2;
            elseif j<(n/2)+1
                q=q+(matrix6(i-1,j)-matrix6(i+1,j))*e_1;
            elseif j>(n/2)+1
                q=q+(matrix6(i-1,j)-matrix6(i+1,j))*e_2;
            end
        elseif j==(n/2)+1-(n/10)-1 && i>=((n/2)+1-(n/10)-1) && i<=((n/2)+1+(n/10)+1) %kiri
            q=q+(matrix6(i,j-1)-matrix6(i,j+1))*e_1;
        elseif i==(n/2)+1+(n/10)+1 && j>=((n/2)+1-(n/10)-1) && j<=((n/2)+1+(n/10)+1) %bawah
            q=q+(matrix6(i+1,j)-matrix6(i-1,j))*e_1;
        elseif j==(n/2)+1+(n/10)+1 && i>=((n/2)+1-(n/10)-1) && i<=((n/2)+1+(n/10)+1) %kanan
            if i==(n/2)+1
                q=q+(matrix6(i,j+1)-matrix6(i,j-1))*(e_1+e_2)/2;
            elseif i<(n/2)+1
                q=q+(matrix6(i,j+1)-matrix6(i,j-1))*e_2;
            elseif i>(n/2)+1
                q=q+(matrix6(i,j+1)-matrix6(i,j-1))*e_1;
            end
        end
    end
end
c=q/2;

contourf(matrix6,'linecolor','non');
colormap(jet(256));
colorbar;
caxis([-1,1]);
