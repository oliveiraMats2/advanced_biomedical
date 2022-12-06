function data = pre_processing_classical(data, D, B)

    A = max(max(data));
    a = min(min(data));

    data = D*log(data) + B;
    
    data = abs(data);
       
    deep_2_k = 8; %2^k deep sample images
    % verificar variavel deep_2_k sampling ------------
    
    DR = 20*log(A/a);
    
    data = 20*(deep_2_k/(DR*log(10) ) )*log(data/a) + B;