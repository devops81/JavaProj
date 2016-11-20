package com.openq.eav.business;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.openq.eav.metadata.AttributeType;
import com.openq.eav.option.IOptionService;
import com.openq.utils.IGlobalConstantsService;
import com.openq.utils.PropertyReader;

public class SelectionCriteriaService extends HibernateDaoSupport implements ISelectionCriteriaService{

    public List getSelectionCriteria(AttributeType[] basicAttributes,
            Map attrValueMap, boolean isNameKey) {

        List results = new ArrayList();

        String TLStatus = globalConstantsService.getValueByName("MSL_OL_TYPE");
        String SOI = globalConstantsService.getValueByName("SPHERE_OF_INFLUENCE");
        String TLStatusValue = "";
        String SOIValue = "";
        String TLStatusAttr = "";
        String SOIAttr = "";
        String selectionCriteriaJSONString = "";
        if (basicAttributes != null && basicAttributes.length > 0 & attrValueMap != null) {
            JSONArray selectionCriteriaJSONArray = new JSONArray();
            Map optionvalueParentMap = optionService.getValueParentMap(PropertyReader.getLOVConstantValueFor("SELECTION_CRITERIA_QUESTION"));
            for (int i=0; i<basicAttributes.length; i++) {
                String selectionCriteriaQues = (isNameKey ? basicAttributes[i].getName() : basicAttributes[i].getDescription());
                String selectionCriteriaAns = ( attrValueMap.get(basicAttributes[i]) != null ? attrValueMap.get(basicAttributes[i]) + "" : "");
                String selectionCriteriaAttName = basicAttributes[i].getName();
                if(TLStatus.equalsIgnoreCase(selectionCriteriaQues)){
                    TLStatusAttr = basicAttributes[i].getAttribute_id()+"";
                    TLStatusValue = selectionCriteriaAns;
                    continue;
                }else if(SOI.equalsIgnoreCase(selectionCriteriaQues)){
                    SOIAttr = basicAttributes[i].getAttribute_id()+"";
                    SOIValue = selectionCriteriaAns;
                    continue;
                }
                JSONObject selectionCriteriaObj = new JSONObject();
                selectionCriteriaObj.put("attributeId", basicAttributes[i].getAttribute_id());
                selectionCriteriaObj.put("question", (selectionCriteriaQues != null ? selectionCriteriaQues.trim() : ""));
                selectionCriteriaObj.put("answer", (selectionCriteriaAns != null ? selectionCriteriaAns.trim() : ""));
                
                String questionType = (String) optionvalueParentMap.get(basicAttributes[i].getAttribute_id()+"");
                selectionCriteriaObj.put("type", questionType);
                
                selectionCriteriaObj.put("selectionCriteriaAttName", (selectionCriteriaAttName != null ? selectionCriteriaAttName.trim() : ""));
                
                selectionCriteriaJSONArray.put(selectionCriteriaObj);
            }
            selectionCriteriaJSONString = selectionCriteriaJSONArray.toString();
        }
        results.add(0, selectionCriteriaJSONString);
        results.add(1, TLStatusAttr);
        results.add(2, TLStatusValue);
        results.add(3, SOIAttr);
        results.add(4, SOIValue);
        return results;
    }
   IGlobalConstantsService globalConstantsService;
    
    public IGlobalConstantsService getGlobalConstantsService() {
        return globalConstantsService;
    }
    public void setGlobalConstantsService(
            IGlobalConstantsService globalConstantsService) {
        this.globalConstantsService = globalConstantsService;
    }
    
    IOptionService optionService;

    public IOptionService getOptionService() {
        return optionService;
    }
    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }
       
}
