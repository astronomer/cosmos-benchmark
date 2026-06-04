{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01362') }},
        {{ ref('model_01204') }},
        {{ ref('model_01086') }}
)
select id, 'model_01705' as name from sources
