function data = pre_processing_compress_log(data)
    A = max(max(data));
    a = min(min(data));
    
    DR = 20*log(A/a);
    
    K = A/(1 - 10^(-DR/20));
    
    I_c = 20*log((data/K) + 10^(-DR/20));
    
    m_1 = -(1 + m);
    
    
    
    
    