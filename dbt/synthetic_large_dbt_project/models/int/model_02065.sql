{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01204') }},
        {{ ref('model_01150') }},
        {{ ref('model_00806') }}
)
select id, 'model_02065' as name from sources
