sFWT = size(FDatWiTimes);
for i = 2:sFWT(1,1)
    if FDatWiTimes(i,6) == FDatWiTimes(i-1,6)
        FDatWiTimes(i,11) = FDatWiTimes(i,9) - FDatWiTimes(i-1,10);
    else
    end
end