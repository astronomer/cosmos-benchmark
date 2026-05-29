{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01090') }},
        {{ ref('model_00979') }},
        {{ ref('model_01339') }}
)
select id, 'model_01755' as name from sources
