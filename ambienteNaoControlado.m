% ambiente nao controlado

% Fecha todas as janelas
close all;

% le a imagem
feijao = imread('imgs/feijao.jpg');

% transforma a imagem em tom de cinza
feijao_a = rgb2gray(feijao);

% histograma
figure, imhist(feijao_a)

% faz o Thresholding
feijao_t = feijao_a < 110;


figure, imhist(feijao_a);

% conta o numero de feijões e rotula numericamente cada um deles
[feijaorot,numObjetos] = bwlabel(feijao_t,4);

% imagem pseudo_color
pseudo_color = label2rgb(feijaorot, @spring, 'c', 'shuffle');

% regionprops(), que retornará em uma
% estrutura, a área (em pixels), o centro de massa e o retângulo que envolve
% (bounding box) cada um dos componentes.
feijao_dados = regionprops(feijaorot,'basic');

% pega o maior feijao
tamanhoMaximo = max([feijao_dados.Area]);

% pega o menor feijao
tamanhoMinimo = min([feijao_dados.Area]);

% media de tamanhos
tamanhoMedio = int32(median([feijao_dados.Area]));

AcimaDaMedia = 0;
AbaixoDaMedia = 0;

% Coloca os numeros dos elementos
for i = 1:numObjetos
   feijao = insertText(feijao,feijao_dados(i).Centroid ,i,'AnchorPoint','LeftBottom','BoxOpacity',0.4); 
   if(feijao_dados(i).Area < tamanhoMedio)
       AbaixoDaMedia = AbaixoDaMedia + 1;
   else
        AcimaDaMedia = AcimaDaMedia + 1;
    end
end

msg = sprintf('Foram Encontrados: %d feijoes.', numObjetos);
feijao = insertText(feijao,[1 1],msg,'BoxColor','yellow','BoxOpacity',0.4); 

msg = sprintf('Maior Feijao: %d px.', tamanhoMaximo);
feijao = insertText(feijao,[1 22],msg,'BoxColor','green','BoxOpacity',0.4); 

msg = sprintf('Menor Feijao: %d px.', tamanhoMinimo);
feijao = insertText(feijao,[1 44],msg,'BoxColor','blue','BoxOpacity',0.4); 

msg = sprintf('Media do Feijao: %d px.', tamanhoMedio);
feijao = insertText(feijao,[1 66],msg,'BoxColor','magenta','BoxOpacity',0.4); 

msg = sprintf('Acima da Media: %d un.', AcimaDaMedia);
feijao = insertText(feijao,[1 114],msg,'BoxColor','yellow','BoxOpacity',0.4); 

msg = sprintf('Abaixo da Media: %d un.', AbaixoDaMedia);
feijao = insertText(feijao,[1 136],msg,'BoxColor','red','BoxOpacity',0.4); 

%resultado final
figure,
imshow(feijao),
for i = 1:numObjetos
    if feijao_dados(i).Area == tamanhoMaximo
        cor = 'g';
    else if feijao_dados(i).Area == tamanhoMinimo
            cor = 'b';
         else if feijao_dados(i).Area < tamanhoMedio
            cor = 'r';
             else
                 cor = 'y';
             end
         end
    end
    rectangle('Position',feijao_dados(i).BoundingBox, 'EdgeColor',cor, 'LineWidth', 1),
end %end for
