{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00281') }},
        {{ ref('model_00502') }},
        {{ ref('model_00187') }}
)
select id, 'model_01032' as name from sources
