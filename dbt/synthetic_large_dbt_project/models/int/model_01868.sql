{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01333') }}
)
select id, 'model_01868' as name from sources
