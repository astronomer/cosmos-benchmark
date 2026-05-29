{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02063') }},
        {{ ref('model_02054') }}
)
select id, 'model_02766' as name from sources
