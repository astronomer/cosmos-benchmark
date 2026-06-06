{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01216') }},
        {{ ref('model_00895') }}
)
select id, 'model_02028' as name from sources
