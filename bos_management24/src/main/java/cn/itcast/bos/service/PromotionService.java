package cn.itcast.bos.service;

import java.util.Date;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import cn.itcast.bos.domain.page.PageBean;
import cn.itcast.bos.domain.take_delivery.Promotion;

public interface PromotionService {

	void save(Promotion promotion);

	Page<Promotion> findPageQuery(Promotion model, Pageable pageable);

	@Path("/findPageQueryWebservice")
	@GET
	@Consumes(value={"application/xml","application/json"})
	@Produces(value={"application/xml","application/json"})
	PageBean<Promotion> findPageQueryWebservice(@QueryParam("page")int page,@QueryParam("rows")int rows);

	@Path("/findById/{id}")
	@GET
	@Consumes(value={"application/xml","application/json"})
	@Produces(value={"application/xml","application/json"})
	Promotion findById(@PathParam("id")Integer id);

	void updateStatus(Date date);

	void zuofeiByIds(String[] arraysIds);

	void sysIndexRepository();


}
