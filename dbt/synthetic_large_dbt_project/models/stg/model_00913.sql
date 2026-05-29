{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00484') }},
        {{ ref('model_00733') }},
        {{ ref('model_00672') }}
)
select id, 'model_00913' as name from sources
