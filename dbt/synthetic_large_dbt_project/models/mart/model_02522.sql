{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02155') }},
        {{ ref('model_02127') }},
        {{ ref('model_01515') }}
)
select id, 'model_02522' as name from sources
