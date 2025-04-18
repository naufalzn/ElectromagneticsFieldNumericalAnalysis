clear all;
close all;
clc;

filename = 'Notes Tubes.xlsx';
matrix3 = readmatrix(filename)

%segmentasi
n=20;
e_1=4*8.854*(10^(-12));
e_2=e_1/4;
x=zeros(n+1,1);
for i=1:n+1
    x(i)=-10+(i-1)*20/n;
end
y=-x;

matrix=zeros(n+1,n+1);
for i=1:n+1
    for j=1:n+1
        if x(j)<=2 && x(j)>=-2 && y(i)==0
            matrix(i,j)=-1;
        elseif ((x(i))^2+(y(j))^2<=(100) && (x(i))^2+(y(j))^2>(10-20/n)^2)
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

matrix4=zeros(16,1);
for i=1:16
    if i>=0 && i<=12
        matrix4(i,1)=4*pi*e_2
    else
        matrix4(i,1)=-4*pi*e_2
    end
end

matrix5 = inv(matrix3)*matrix4;
coba=inv(matrix3);
for i=1:16
    if i>=0 && i<=12
        matrix5(i,1)=matrix5(i,1) * 5/3*pi
    end
end
matrix6=[-sqrt(75),5;
    sqrt(75),5;
    -sqrt(75),-5;
    sqrt(75),-5;
    -5,sqrt(75);
    5,sqrt(75);
    -5,-sqrt(75);
    5,-sqrt(75);
    0,10;
    -10,0;
    10,0;
    0,-10;
    -1.5,0;
    -0.5,0;
    0.5,0;
    1.5,0;]  
for i=1:n+1
    for j=1:n+1
        sum=0;
        if matrix2(i,j)~=0
            for k=1:16
                matrix(i,j)=matrix5(k,1)/(e_1*pi*(sqrt((matrix6(k,1)-x(j))^2+(matrix6(k,2)-y(i))^2)));
            end
        end
    end
end
q=0
for i=1:16
    q=q+matrix5(i,1);
end
C=q/2;

contourf(matrix,'linecolor','non');
colormap(jet(256));
colorbar;
caxis([-1,1]);
