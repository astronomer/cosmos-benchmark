{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00168') }},
        {{ ref('model_00503') }},
        {{ ref('model_00441') }}
)
select id, 'model_01406' as name from sources
