{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01867') }},
        {{ ref('model_02199') }}
)
select id, 'model_02464' as name from sources
