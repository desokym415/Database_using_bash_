#!/bin/bash

if [ -e "Databases" ]
   then 
      :
   else 
      mkdir "Databases"
   fi 

select option in Create_DB Connect_DB Delete_DB Exit 
do 
case $option in 
##################################################################
Create_DB) 
   read -p "Please enter your DataBase name: " DBname

   if [[ "$DBname" = "" ]]
      then
      echo "the name can not be empty"
   elif [ -e "./Databases/$DBname" ]
   then
       echo "Database name already exists"
   elif [[ "$DBname" = *" "* ]]
      then
      echo "the name can not has spaces"
   elif [[ "$DBname" =~ "/" ]]
      then
      echo "the name can not has back slache"
   else
      mkdir "Databases"/"$DBname"
      echo "DB created successfully"
   fi 
;;

##################################################################

Connect_DB)
read -p "Please enter your DataBase name: " DBname_toConnect

  if [[ "$DBname_toConnect" = "" ]]          
      then                                   
      echo "You do not enter the name"       
      

   elif [ -e "./Databases/$DBname_toConnect" ]                                 
   then 
       cd "./Databases/$DBname_toConnect"
       echo "You are now connected to $DBname_toConnect DB"

select to_do in Create_table List_tables Drop_table Data_Manipulation back
       do 
       case $to_do in
           #######################################################
           Create_table)
               columns_no=1
               read -p "Please enter table name: " table_name
                
               if [[ "$table_name" = "" ]]
               then
               echo "the name can not be empty"
               
               elif [ -e "./$table_name" ]
               then
               echo "Table already exists"

               elif [[ "$table_name" = *" "* ]]
               then

               echo "the name can not has spaces"
               elif [[ "$table_name" =~ "/" ]]
               then
               echo "the name can not has back slache"

               else
               touch "$table_name"
               echo "table created successfully"
               read -p "Please enter number of columns: " i
               
               if [[ "$i" = "" ]]
               then
               echo "You created an empty table called $table_name"
      
               elif [ $i -lt 0 ] 
               then 
               echo "you should enter a positive number"

               elif [ $i -eq 0 ]
               then
               echo "You created an empty table called $table_name"               
               
               else
        
               read -p "Please enter the primary key column: " primary_col

               printf "$primary_col|" >> "$table_name"
              
               
               while [[ $columns_no < $i ]]
               do
               read -p "enter the name of the next column: " col_name
               printf "$col_name|" >> "$table_name"
               ((columns_no+=1))
               done

               fi 
        fi      
       ;;
       ###################################################
       List_tables)
       ls 
       ;;
       ###################################################
       Drop_table) #begin
       read -p "enter the table name you want to drop: " tab_name
       if [ -f "./$tab_name" ]
       then       
       echo "Are you sure you want to delete the table ?"
 
       select to_do in Yes No 
       do 
       case $to_do in
            Yes)
               rm $tab_name 
               echo "$tab_name droped"
               break
            ;;   
            No)
               break
            ;;
       esac 
       done

       else 
       echo "there is no table called $tab_name"
       fi
       ;;

       #################################      
       Data_Manipulation)

       read -p "enter the table name: " DML_table

       if [[ "$DML_table" = "" ]]
         then
         echo "the name can not be empty"

       elif [[ "$DML_table" = *" "* ]]
         then
         echo "the name can not has spaces"
      
       elif [[ "$DML_table" =~ "/" ]]
         then
         echo "the name can not has back slache"
       
       elif [ -e "./$DML_table" ]
         then
       sed -i '/^$/d' $DML_table #delete all empty lines
       select DML in Insert_row Update_row Delete_row Select back 
       do 
       case $DML in
#########################################################################
            Select)

              select selection_type in select_by_id select_ALL
              do
                case $selection_type in
                #################################################
                 select_by_id)

                  read -p "The ID you want to select: " id_to_select
                   if [[ "$id_to_select" = "" ]]
                   then
                      echo "the id can not be empty"

                   elif [[ "$id_to_select" = *" "* ]] 
                   then
                      echo "the id can not has spaces"
      
                   elif [[ "$id_to_select" =~ "/" ]]
                   then
                      echo "the id can not has back slache"
                   elif [[ "$id_to_select" =~ "*" ]]
                   then
                      echo "the id can not has *"
                  else

                  select_result=$(awk -F'|' -v id="$id_to_select" '$1 == id' $DML_table)

                   if [ -z "$select_result" ]
                   then 
                       echo "The ID does not exist"
                   else 
                       echo "$select_result"
                   fi
                   fi
                   ;;
                 #################################################
                 select_ALL)
                   select_result=$(awk '{ print }' "$DML_table")
                   echo "$select_result"                   
                   ;;
                   esac
                   done

            ;;
            Insert_row)

               sed -i '/^$/d' $DML_table #delete all empty lines
               Col_no=$(awk -F'|' '{print NF; exit}' $DML_table)              
               loop_var=1 
               new_line_bool=false 
               row_count=$(wc -l < $DML_table)

               
               printf "\n" >> "$DML_table" #new line
              
               if_empty=$(awk -F '|' '{print $1}' $DML_table)
               id_exists=false
               

               ####################################outer_loop
               while [[ $loop_var -lt $Col_no ]]
               do
               line=$(head -n 1 $DML_table | awk -v var=$loop_var -F '|' '{print $var}')

               read -p "enter the $line: " col_content

               if [[ "$col_content" =~ "*" ]]
               then
               echo "the content can not has *"
               break
               fi 

               if [[ "$loop_var" -eq 1 ]]
               then

               if [[ "$col_content" = "" ]]
               then
               echo "the id can not be empty"
               break
               
               elif [[ "$col_content" = *" "* ]]
               then
               echo "the id can not has spaces"
               break
               
               elif [[ "$col_content" =~ "/" ]]
               then
               echo "the id can not has back slache"
               break
               
               elif [[ "$col_content" =~ "*" ]]
               then
               echo "the id can not has *"
               break

               else
 
               for x in $if_empty 
               do
                   if [ $col_content = $x ] 
                   then
                      echo "this id already exists"
                      id_exists=true
                      break
                   fi
               done
               fi

               fi
               
               
               if [[ "$id_exists" = false ]]
               then
               
               if [[ "$loop_var" -eq $Col_no-1 ]]
               then
               printf "$col_content" >> "$DML_table" #writing in table
               else
               printf "$col_content|" >> "$DML_table" #writing in table
               fi 

               else
               break
               fi

               ((loop_var++))
               done
            ;;   
###############################################################################
            Update_row)

            sed -i '/^$/d' $DML_table #delete all empty lines
            read -p "Please enter the id of the row you want to update: " id_to_upd

            if [[ "$id_to_upd" = "" ]]
               then
               echo "the id can not be empty"

               elif [[ "$id_to_upd" = *" "* ]]
               then
               echo "the id can not has spaces"
      
               elif [[ "$id_to_upd" =~ "/" ]]
               then
               echo "the id can not has back slache"
               elif [[ "$id_to_upd" =~ "*" ]]
               then
               echo "the id can not has *"
               else

            id_search_result=$(awk -F'|' -v id="$id_to_upd" '$1 == id' $DML_table)
               
               if [ -z "$id_search_result" ]
               then 
                     echo "The ID does not exist"
               else  

                     Head_line=$(head -n 1 $DML_table)
                     echo ""
                     echo "$Head_line"
                     echo "$id_search_result"
                     echo ""               
                     echo "Is this the row you want to update"

                     select to_do2 in Yes No 
                       do 
                        case $to_do2 in
                        Yes)
read -p "Please enter the column you want to update: " upd_col_name
                   
                     if [[ "$upd_col_name" = "" ]]
                     then
                     echo "the id can not be empty"

                     elif [[ "$upd_col_name" = *" "* ]]
                     then
                     echo "the name can not has spaces"
      
                     elif [[ "$upd_col_name" =~ "/" ]]
                     then
                     echo "the name can not has back slache"

                     elif [[ "$upd_col_name" =~ "*" ]]
                     then
                     echo "the name can not has *"
                     else

                        fields=$(echo $Head_line | tr "|" "\n")
                        col_order=0
                        i1=1
                        upd_col_existed=false

                        for field in $fields
                        do

                        if [[ "$upd_col_name" == "$field" ]]
                        then
                        upd_col_existed=true
                        col_order=$i1
                        break
                        else
                        upd_col_existed=false
                        fi

                         ((i1+=1))
                        done
                        
                        if [[ "$upd_col_existed" == true ]]
                        then
                        if [[ $col_order -eq 1 ]]
                        then 
                        echo "You can not edit the id"
                        break
                        fi

read -p "Please enter the new value of $upd_col_name: " new_value


the_record22=$(echo $id_search_result | tr " " "*")

the_record=$(echo $the_record22 | tr "|" "\n")
i2=1
new_row=""

                        for col_field in $the_record
                        do                       

                        if [[ "$i2" == "$col_order" ]]
                        then
                        new_row="$new_row|$new_value"
                        else
                        new_row="$new_row|$col_field"
                        fi
                        
                         ((i2+=1))
                        done

                        new_row="${new_row:1}" 
                        new_row=$(echo $new_row | tr "*" " ")
                        echo "$new_row"

                sed -i "s/$id_search_result/$new_row/" $DML_table
                        echo "Updated successfuly"
                        break
                        else
                        echo "Not existed"
                        fi
                       fi
                        ;;   

                        No)
                        break
                        ;;

                        esac 
                        done

               fi
            fi
            ;;
##################################################################################
            Delete_row)
               read -p "Please enter the id of the row you want to delete: " id_to_del

               if [[ "$id_to_del" = "" ]]
               then
               echo "the id can not be empty"

               elif [[ "$id_to_del" = *" "* ]]
               then
               echo "the id can not has spaces"
      
               elif [[ "$id_to_del" =~ "/" ]]
               then
               echo "the id can not has back slache"
               elif [[ "$id_to_del" =~ "*" ]]
               then
               echo "the id can not has *"
               else
               sed -i '/^$/d' $DML_table #delete all empty lines
               sed -i '/^'$id_to_del'|/d' $DML_table
               echo "Deleted successfuly"
               fi
            ;;
            Back)
            break
            break
            ;;
       esac 
       done
       else
       echo "This table not found" 
       fi
       ;;
       back)
       break 
       ;;
   
       esac
       done
   
   else
      echo "DB Not found"
   fi 
;;


#####################################################################

Delete_DB)
read -p "Please enter DataBase name you want to delete: " DBname_toDelete
   if [ -e "Databases/$DBname_toDelete" ]
   then

     if [ -n "$(find Databases/$DBname_toDelete -prune -empty 2>/dev/null)" ]
     then 
       rmdir "Databases/$DBname_toDelete"
       echo "Database deleted successfully"
     else
       echo "The DB not empty, are you sure you want to delete it ?"
       select confirmation in "yes and back" back "No and Exit"
       do
       case $confirmation in

       "yes and back")
       rm -r "Databases/$DBname_toDelete"
       echo "Database deleted successfully"
       break 
       ;;
       back)
       break 
       ;;
       "No and Exit")
       exit 
       ;;
       esac 
       done
      
     fi 
   else
      echo "DB Not found"
   fi 
;;

Exit)
   break
esac
done
