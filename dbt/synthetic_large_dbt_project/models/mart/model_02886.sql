{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01729') }},
        {{ ref('model_01960') }},
        {{ ref('model_01705') }}
)
select id, 'model_02886' as name from sources
