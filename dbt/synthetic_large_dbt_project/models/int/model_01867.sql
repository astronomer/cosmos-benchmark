{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00845') }},
        {{ ref('model_01257') }}
)
select id, 'model_01867' as name from sources
