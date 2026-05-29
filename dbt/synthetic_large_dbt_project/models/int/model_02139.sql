{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00914') }}
)
select id, 'model_02139' as name from sources
