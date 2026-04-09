Gabriel Chaves

chaves1135@gmail.com

Esses códigos foram desenvolvidos inicialmente para uso próprio em pesquisa e estudos, portanto muitos não estão bem comentados.

Os códigos cujos nomes começam com 'demonstracao' ou 'estudo' foram criados para fins didáticos.

Breve resumo de cada arquivo na ordem em que os mesmos aparecem no diretório:

- FILTRO_ESPACIAL_CSP_construção

Função que cria a matriz de transfomação dos dados de EEG multicanal segundo a técnica Common SpatiaL Patterns.

- SL_spatial_filter

Função que cria a matriz de transformação linear dos dados de EEG multicanal segundo a técnica da Superfície Laplaciana com splines esféricas.

- change_fs

Função que aumenta a 'frequência de amostragem' de um sinal em qualquer quantidade.

- coordinates_10_5

Código que contém as coordenadas cartesianas e polares de 147 posições do escalpo, assumindo a geometria esférica.

- correlacao

Função que faz a correlação cruzada entre dois sinais, similar à função xcorr do matlab. No entanto, diferente da funcao xcorr do matlab, quando os sinais tem tamanhos diferentes, os valores da funcao que seriam forcosamente nulos na funcao xcorr sao retirados do resultado nesta funcao.

- demonstracao_ERD

O código cria pseudo-fontes de EEG com dessincronização em um dado instante e sincronização posterior, simulando um ERD seguido de ERS. Em seguida, utiliza três formas de computar o ERD/ERS e plota os resultados.

- demonstracao_butter

O código cria um sinal com várias frequências e aplica filtros butterworth para ilustrar como o filtro e os seus parâmetros (ordem e frequencias de corte) afetam o sinal resultante. Além disso, implementa o filtro sem a função 'filter' do matlab para demonstrar como o procedimento é feito 'manualmente' gerando o mesmo resultado.

- demonstracao_coherence

Cria dois sinais com várias frequências onde algumas frequências são coindicentes e outras não, para investigar o cálculo manual da coerência.

- demonstracao_filtro_frequencia_fir

Implementa um filtro FIR com cálculo 'manual' de convolução no domínio do tempo. Ilustra como o filtro FIR afeta os sinais com passa-baixas e passa-altas. Mostra também o filtro no domínio do tempo e sua resposta em frequência.

- demonstracao_sigma_delta_adc

Ilustra o processo de conversão analógico-digital do conversor sigma-delta.

- demonstracao_teorema_amostragem

Demonstra o efeito de aliasing nos sinais digitalizados com frequências de amostragens inferiores à frequência de Nyquist.

- estudo_DWT

Mostra os coeficientes da DWT de um sinal construído com diferentes frequências variáveis no tempo. Os parâmetros do sinal podem ser alterados para se estudar o impacto nos coeficientes da DWT.

- estudo_correlacao_covariancia

Analisa as funções do matlab e diferentes cálculos manuais dessas duas funções.

- plot_positions_generic_polar

Plota posições de eletrodos em 3 dimensões, podendo ser no padrão 10-10 ou em coordenadas arbitrárias.

- rej_artefatos

Função que elimina repetições de uma tarefa em que o sinal está potencialmente contaminado com interferências ou artefatos oculares.


