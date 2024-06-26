module parking (
    input car_entered, is_uni_car_entered, car_exited, is_uni_car_exited,
    input [4:0] hour,
    output reg [8:0] uni_parked_car, parked_car, uni_vacated_space, vacated_space,
    output wire uni_is_vacated_space, is_vacated_space
);

assign uni_is_vacated_space = (uni_vacated_space > 0);
assign is_vacated_space = (vacated_space > 0);
reg [8:0] total_free_space;
reg [8:0] total_uni_space;

initial begin
    uni_parked_car = 0;
    parked_car = 0;
    total_free_space = 200;
    total_uni_space = 500;
    vacated_space = 200;
    uni_vacated_space = 500;
end

always @(hour) begin
    // if(uni_parked_car > total_uni_space) begin
    //     uni_parked_car = total_uni_space;
    //     parked_car = parked_car + uni_parked_car - total_uni_space
    // end
    if(hour >= 13 && hour < 16 && uni_parked_car <= total_uni_space - 50) begin
        total_free_space = total_free_space + 50;
        total_uni_space = total_uni_space - 50;
        uni_vacated_space = total_uni_space - uni_parked_car;
        vacated_space = total_free_space - parked_car;
    end
    else if(hour == 16 && uni_parked_car <= 200) begin
        total_free_space = 500;
        total_uni_space = 700 - total_free_space;
        uni_vacated_space = total_uni_space - uni_parked_car;
        vacated_space = total_free_space - parked_car;
    end
    else if(hour >= 13 && hour < 17)
        $display("failed to increase free capacity");
end

always @(posedge car_entered) begin
    if(is_uni_car_entered) begin
        if(uni_is_vacated_space) begin
            uni_parked_car = uni_parked_car + 1;
            uni_vacated_space = uni_vacated_space - 1;
        end
    end
    else begin
        if(is_vacated_space) begin
            parked_car = parked_car + 1; 
            vacated_space = vacated_space - 1;
        end
    end
end

always @(posedge car_exited) begin
    if(is_uni_car_exited) begin
        uni_parked_car = uni_parked_car - 1;
        uni_vacated_space = uni_vacated_space + 1;
    end
    else begin
        parked_car = parked_car - 1;
        vacated_space = vacated_space + 1;
    end
end
    
endmodule
